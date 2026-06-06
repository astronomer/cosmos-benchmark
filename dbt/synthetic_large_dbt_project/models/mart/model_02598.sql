{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02102') }},
        {{ ref('model_01870') }}
)
select id, 'model_02598' as name from sources
