{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02091') }},
        {{ ref('model_01910') }}
)
select id, 'model_02269' as name from sources
