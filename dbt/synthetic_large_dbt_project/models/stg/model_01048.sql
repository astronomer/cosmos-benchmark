{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00293') }},
        {{ ref('model_00474') }},
        {{ ref('model_00646') }}
)
select id, 'model_01048' as name from sources
