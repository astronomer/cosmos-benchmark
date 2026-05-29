{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01499') }},
        {{ ref('model_01434') }}
)
select id, 'model_02171' as name from sources
