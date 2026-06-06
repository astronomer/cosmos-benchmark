{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01340') }},
        {{ ref('model_00751') }}
)
select id, 'model_01759' as name from sources
