{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02067') }},
        {{ ref('model_01567') }},
        {{ ref('model_01846') }}
)
select id, 'model_02509' as name from sources
