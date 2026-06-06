{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01992') }},
        {{ ref('model_02178') }},
        {{ ref('model_01567') }}
)
select id, 'model_02798' as name from sources
