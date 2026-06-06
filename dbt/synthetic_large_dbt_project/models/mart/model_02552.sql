{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01908') }},
        {{ ref('model_01636') }},
        {{ ref('model_02240') }}
)
select id, 'model_02552' as name from sources
