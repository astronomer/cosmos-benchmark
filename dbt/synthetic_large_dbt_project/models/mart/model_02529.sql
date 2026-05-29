{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01617') }},
        {{ ref('model_01618') }},
        {{ ref('model_01662') }}
)
select id, 'model_02529' as name from sources
