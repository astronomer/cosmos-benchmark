{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00918') }},
        {{ ref('model_00805') }}
)
select id, 'model_01906' as name from sources
