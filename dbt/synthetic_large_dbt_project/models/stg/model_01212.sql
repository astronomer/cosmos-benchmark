{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00659') }},
        {{ ref('model_00727') }},
        {{ ref('model_00476') }}
)
select id, 'model_01212' as name from sources
