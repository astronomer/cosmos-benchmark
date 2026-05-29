{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00877') }},
        {{ ref('model_01109') }}
)
select id, 'model_01957' as name from sources
