{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00613') }},
        {{ ref('model_00567') }}
)
select id, 'model_01089' as name from sources
