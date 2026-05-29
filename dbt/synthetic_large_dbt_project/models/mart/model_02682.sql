{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01938') }},
        {{ ref('model_02134') }}
)
select id, 'model_02682' as name from sources
