{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02114') }},
        {{ ref('model_02247') }},
        {{ ref('model_02192') }}
)
select id, 'model_02994' as name from sources
