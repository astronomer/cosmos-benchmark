{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01170') }},
        {{ ref('model_00988') }},
        {{ ref('model_01363') }}
)
select id, 'model_01613' as name from sources
